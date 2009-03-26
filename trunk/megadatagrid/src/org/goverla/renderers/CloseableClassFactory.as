package org.goverla.renderers
{
	import mx.core.ClassFactory;

	public class CloseableClassFactory extends ClassFactory
	{
		public function CloseableClassFactory(generator : Class = null)
		{
			super(generator);
		}

		public override function newInstance() : *
		{
			var instance : CloseableRendererDecorator = new CloseableRendererDecorator(generator);

			if (properties != null)
			{
				for (var p : String in properties)
				{
					instance[p] = properties[p];
				}
			}

			return instance;
		}
	}
}