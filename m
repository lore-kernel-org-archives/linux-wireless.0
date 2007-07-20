Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3603 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755317AbXGTPDj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 11:03:39 -0400
Date: Fri, 20 Jul 2007 10:37:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: Michael Wu <flamingice@sourmilk.net>, cebbert@redhat.com,
	linville@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: p54usb: Don't run DMA off code segment
Message-ID: <20070720143713.GD7428@tuxdriver.com>
References: <20070716231051.0971d9c0.zaitcev@redhat.com> <200707180048.35762.flamingice@sourmilk.net> <20070719222716.e4152774.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20070719222716.e4152774.zaitcev@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 19, 2007 at 10:27:16PM -0700, Pete Zaitcev wrote:
> On Wed, 18 Jul 2007 00:48:31 -0700, Michael Wu <flamingice@sourmilk.n=
et> wrote:
>=20
> > On Monday 16 July 2007 23:10, Pete Zaitcev wrote:
> > > +=A0=A0=A0=A0=A0=A0=A0if ((err =3D p54u_bulk_msg(priv, P54U_PIPE_=
DATA, buf, 4)) !=3D 0) {
> > Please follow the style used elsewhere in this function and do it l=
ike:
> >=20
> >   err =3D p54u_bulk_msg(priv, P54U_PIPE_DATA, buf, 4);
> >   if (err) {
> >=20
> > The rest of the patch looks fine. Thanks for fixing this.
>=20
> How about this, then?

<snip>

That is exactly the way I committed it.  Thanks, Pete!

John
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
