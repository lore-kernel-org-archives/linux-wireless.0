Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.pescomnet.cz ([82.100.5.251]:46332 "EHLO ns.pescomnet.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbYKDB6x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 20:58:53 -0500
Message-ID: <490FAC3B.6030205@centrum.cz> (sfid-20081104_025859_080362_C23DDE54)
Date: Tue, 04 Nov 2008 02:58:19 +0100
From: =?ISO-8859-2?Q?Ond=F8ej_Ku=E8era?= <ondrej.kucera@centrum.cz>
MIME-Version: 1.0
To: Marcos Barbosa <marcosestevesbarbosa@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>, jikos@suse.cz,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] PROBLEM: Led for wifi blinking all the time
References: <490A5D39.1090605@centrum.cz> <20081031145434.GB4310@tuxdriver.com> <42bbb5c30810311159v50785ac7jfc8ef8eb3e32ea9b@mail.gmail.com>
In-Reply-To: <42bbb5c30810311159v50785ac7jfc8ef8eb3e32ea9b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Marcos Barbosa wrote:
> Traffic exists all the time, because the commands to control
> connection. To cancel all traffic, down the wireless interface.

OK, let me rephrase. It may by true that from a low-level point of view=
=20
there exists some traffic all the time. But let's see it from user's=20
point of view. With 2.6.26 I connected to network during which the led=20
was blinking. After the connection was established, it stopped blinking=
=20
and was just on. Then when I started downloading something (wget=20
http://server.com/foo.bar), it started blinking and shortly after the=20
download was completed, it stopped to be just "on" again. I consider=20
this a very reasonable behavior. With 2.6.27 it is blinking really all=20
the time, whether the user is consciously downloading/uploading some=20
data or not. The main problem is that such periodic non-stop blinking i=
s=20
very eye catching and it draws your attention away from the things you=20
are actually doing. So I really believe this is a regression. One more=20
reason, even though I'm not sure if I should even bring it up - on MS=20
Windows it behaves more or less in a similar manner as with 2.6.26=20
kernel. Now I'm far from saying that things should work the way they=20
work on Windows but in this case I think they actually have it right.

Ond=F8ej


--=20
Cheers,
Ond=F8ej Ku=E8era
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
