package org.goverla.renderers
{
	import flash.events.MouseEvent;
	
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	import mx.core.UIComponent;

	public class RollOverRendererInjector
	{
		public function set rightOffset(value : int) : void
		{
			_rightOffset = value;
		}

		public function get rightOffset() : int
		{
			return _rightOffset;
		}

		public function set topOffset(value : int) : void
		{
			_topOffset = value;
		}

		public function get topOffset() : int
		{
			return _topOffset;
		}

		public function RollOverRendererInjector(injectingComponentType : IFactory, 
			renderer : UIComponent, createInjectingComponent : Function = null, 
				removeInjectingComponentAllowed : Function = null)
		{
			_createInjectingComponentAllowed = createInjectingComponent;
			_removeInjectingComponentAllowed = removeInjectingComponentAllowed;
			initialize(injectingComponentType, renderer);
		}

		public function freeResources() : void
		{
			_renderer.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_renderer.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);

			if (_injectingComponent != null)
			{
				if (_renderer.contains(_injectingComponent))
				{
					_renderer.removeChild(_injectingComponent);
				}

				_injectingComponent.removeEventListener(MouseEvent.MOUSE_OUT, 
					onInjectingComponentMouseOut);
				_injectingComponent = null;
			}
		}

		public function reset(injectingComponentType : IFactory, renderer : UIComponent) : void
		{
			freeResources();
			initialize(injectingComponentType, renderer);
		}

		protected function initialize(injectingComponentType : IFactory, renderer : UIComponent) : void
		{
			_injectingComponentType = injectingComponentType;
			_renderer = renderer;

			_renderer.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			_renderer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}

		private function onMouseOver(event : MouseEvent) : void
		{
			createInjectingComponent();
		}

		private function onMouseOut(event : MouseEvent) : void
		{
			if (event.relatedObject == null || _injectingComponent != null &&
				!_injectingComponent.contains(event.relatedObject))
			{
				removeInjectingComponent();
			}
		}

		private function onInjectingComponentMouseOut(event : MouseEvent) : void
		{
			if (event.relatedObject == null || _renderer == event.relatedObject ||
				! _renderer.contains(event.relatedObject))
			{
				removeInjectingComponent();
			}
		}

		protected function createInjectingComponent() : void
		{
			if (_injectingComponent == null &&
				(_createInjectingComponentAllowed == null ||
					_createInjectingComponentAllowed()))
			{
				_injectingComponent = UIComponent(_injectingComponentType.newInstance());
				_injectingComponent.addEventListener(MouseEvent.MOUSE_OUT, onInjectingComponentMouseOut);
				if (_injectingComponent is IDropInListItemRenderer)
				{
					IDropInListItemRenderer(_injectingComponent).listData = IDropInListItemRenderer(_renderer).listData;
				}

				if (_injectingComponent is IDataRenderer)
				{
					IDataRenderer(_injectingComponent).data = IDataRenderer(_renderer).data;
				}
				_injectingComponent.width = _renderer.width - rightOffset;
				_injectingComponent.height = _renderer.height - topOffset;
				_renderer.addChild(_injectingComponent);
				_renderer.invalidateDisplayList();
			}
		}

		protected function removeInjectingComponent() : void
		{
			if (_injectingComponent != null && _renderer.contains(_injectingComponent) &&
				(_removeInjectingComponentAllowed == null ||
					_removeInjectingComponentAllowed()))
			{
				_injectingComponent.removeEventListener(MouseEvent.MOUSE_OUT, onInjectingComponentMouseOut);
				_renderer.removeChild(_injectingComponent);
				_injectingComponent = null;
			}
		}

		protected var _injectingComponent : UIComponent;

		protected var _renderer : UIComponent;

		protected var _injectingComponentType : IFactory;

		private var _createInjectingComponentAllowed : Function;

		private var _removeInjectingComponentAllowed : Function;

		private var _rightOffset : int = 0;

		private var _topOffset : int = 0;
	}
}