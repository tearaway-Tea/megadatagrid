package org.goverla.renderers
{
	import flash.events.MouseEvent;

	import mx.controls.Image;

	import org.goverla.controls.advancedDataGridClasses.MegaDataGridColumn;
	import org.goverla.controls.advancedDataGridClasses.MegaDataGridColumnGroup;
	import org.goverla.events.HeaderRendererEvent;

	[Style(name="icon", type = "Class", inherit = "no")]

	public class CloseableHeaderRenderer extends UIComponentRenderer
	{
		public override function set data(value : Object) : void
		{
			super.data = value;
			_dataChanged = true;
			invalidateProperties();
		}

		protected function get icon() : Class
		{
			return getStyle("icon");
		}

		protected override function createChildren() : void
		{
			super.createChildren();

			if (_image == null)
			{
				_image = new Image();
				_image.buttonMode = true;
				_image.visible = false;
				_image.addEventListener(MouseEvent.CLICK, onImageClick);
				_image.alpha = 0.8;
				_image.width = 9
				_image.height = 9;

				addChild(_image);
			}
		}

		protected override function commitProperties() : void
		{
			super.commitProperties();

			if (_dataChanged)
			{
				_dataChanged = false;

				_image.visible = false;

				if (data is MegaDataGridColumn && MegaDataGridColumn(data).closeable ||
					data is MegaDataGridColumnGroup && MegaDataGridColumnGroup(data).closeable)
				{
					_image.visible = true;
					_image.source = icon;
				}

				invalidateDisplayList();
			}
		}

		protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (_image.visible)
			{
				_image.move(2, 1);
			}
		}

		private function onImageClick(event : MouseEvent) : void
		{
			if (data != null)
			{
				Object(data).visible = false;
				dispatchEvent(new HeaderRendererEvent(HeaderRendererEvent.HEADER_CLOSED, true));
			}
		}

		private var _image : Image;

		private var _dataChanged : Boolean = false;

	}
}