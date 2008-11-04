Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28020 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbYKDRfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 12:35:04 -0500
Subject: Re: [ipw3945-devel] PROBLEM: Led for wifi blinking all the time
From: reinette chatre <reinette.chatre@intel.com>
To: =?UTF-8?Q?Ond=C5=99ej_Ku=C4=8Dera?= <ondrej.kucera@centrum.cz>
Cc: Marcos Barbosa <marcosestevesbarbosa@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"jikos@suse.cz" <jikos@suse.cz>, "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <490FAC3B.6030205@centrum.cz>
References: <490A5D39.1090605@centrum.cz>
	 <20081031145434.GB4310@tuxdriver.com>
	 <42bbb5c30810311159v50785ac7jfc8ef8eb3e32ea9b@mail.gmail.com>
	 <490FAC3B.6030205@centrum.cz>
Content-Type: text/plain; charset=utf-8
Date: Tue, 04 Nov 2008 09:35:33 -0800
Message-Id: <1225820133.1115.522.camel@rc-desk> (sfid-20081104_183511_419985_A48CAADA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-03 at 17:58 -0800, Ond=C5=99ej Ku=C4=8Dera wrote:
> Hi,
>=20
> Marcos Barbosa wrote:
> > Traffic exists all the time, because the commands to control
> > connection. To cancel all traffic, down the wireless interface.
>=20
> OK, let me rephrase. It may by true that from a low-level point of vi=
ew=20
> there exists some traffic all the time. But let's see it from user's=20
> point of view. With 2.6.26 I connected to network during which the le=
d=20
> was blinking. After the connection was established, it stopped blinki=
ng=20
> and was just on. Then when I started downloading something (wget=20
> http://server.com/foo.bar), it started blinking and shortly after the=
=20
> download was completed, it stopped to be just "on" again. I consider=20
> this a very reasonable behavior. With 2.6.27 it is blinking really al=
l=20
> the time, whether the user is consciously downloading/uploading some=20
> data or not. The main problem is that such periodic non-stop blinking=
 is=20
> very eye catching and it draws your attention away from the things yo=
u=20
> are actually doing. So I really believe this is a regression. One mor=
e=20
> reason, even though I'm not sure if I should even bring it up - on MS=
=20
> Windows it behaves more or less in a similar manner as with 2.6.26=20
> kernel. Now I'm far from saying that things should work the way they=20
> work on Windows but in this case I think they actually have it right.

Could you please add your feedback to
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1771 ?

Thanks

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
