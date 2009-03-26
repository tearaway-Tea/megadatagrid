package org.goverla.renderers
{
	import flash.events.MouseEvent;

	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.IDataRenderer;
	import mx.core.UIComponent;

	public class CloseableRendererDecorator extends UIComponentRenderer
	{
		public override function get listData() : BaseListData
		{
			return _listData;
		}

		public override function set listData(value : BaseListData) : void
		{
			_listData = value;
			_listDataChanged = true;
			invalidateProperties();
		}

		public override function get data() : Object
		{
			var result : Object = null;

			if (_renderer != null && _renderer is IDataRenderer)
			{
				result = IDataRenderer(_renderer).data;
			}
			return result;
		}

		public override function set data(value : Object) : void
		{
			_data = value;
			_dataChanged = true;
			invalidateProperties();
		}

		public function CloseableRendererDecorator(rendererType : Class)
		{
			super();
			_rendererType = rendererType;
			_rendererInjector = new RollOverRendererInjector(new ClassFactory(CloseableHeaderRenderer), this);
		}

		public override function setStyle(styleProp : String, newValue : *) : void
		{
			_renderer.setStyle(styleProp, newValue);
		}

		protected override function createChildren() : void
		{
			super.createChildren();

			if (_renderer == null)
			{
				_renderer = new _rendererType();

				addChild(_renderer);
			}
		}

		protected override function measure() : void
		{
			super.measure();
			measuredHeight = _renderer.measuredHeight;
			measuredWidth = _renderer.measuredWidth;
		}

		protected override function commitProperties() : void
		{
			super.commitProperties();

			if (_dataChanged && _renderer != null && _renderer is IDataRenderer)
			{
				_dataChanged = false;
				IDataRenderer(_renderer).data = _data;
			}

			if (_listDataChanged && _renderer != null && _renderer is IDropInListItemRenderer)
			{
				_listDataChanged = false;
				IDropInListItemRenderer(_renderer).listData = _listData;
			}
			// as grid sometimes calls this method for the renderer intentionally
			// the call should be transfered to the inner _renderer current rernderer is
			// substituting
			_renderer.invalidateProperties();
		}

		// this method is essential for proper behaviour of _renderer
		// when the header part is getting hovered. see also mouseOverHandler method
		// of AdvancedDataGrid
		public function mouseEventToHeaderPart(event : MouseEvent) : String
		{
			if (_renderer.hasOwnProperty("mouseEventToHeaderPart"))
			{
				return String(Object(_renderer).mouseEventToHeaderPart(event));
			}
			return null;
		}

		protected override function updateDisplayList(w : Number, h : Number) : void
		{
			super.updateDisplayList(w, h);

			graphics.clear();

			_renderer.x = 0;
			_renderer.y = 0;
			_renderer.setActualSize(w, h);
		}

		protected override function applyStyles() : void
		{
			// do nothing - we do not need any styles for the decorator. of of the should be considered in the nested renderer.
		}

		private var _rendererType : Class;

		private var _renderer : UIComponent;

		private var _data : Object;

		private var _dataChanged : Boolean = true;

		private var _listData : BaseListData;

		private var _listDataChanged : Boolean = true;

		private var _rendererInjector : RollOverRendererInjector;
	}
}