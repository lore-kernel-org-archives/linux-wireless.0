Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23104.mail.ird.yahoo.com ([217.146.189.44]:21396 "HELO
	web23104.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756105AbZAAOjo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jan 2009 09:39:44 -0500
Date: Thu, 1 Jan 2009 14:39:41 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [linux-pm] rtl8187 usb wifi adaptor causes suspend hang
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	=?iso-8859-1?Q?Stefanik_G=E1bor?= <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org,
	linux-pm@lists.linux-foundation.org,
	USB list <linux-usb@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <69e28c910901010540r5e79431cjf6ad1a76f06ff0fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <120849.67182.qm@web23104.mail.ird.yahoo.com> (sfid-20090101_154000_884881_41E716C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Thu, 1/1/09, Stefanik G=E1bor <netrolller.3d@gmail.com> wrote:

> On Thu, Jan 1, 2009 at 2:07 PM, Alan Jenkins
> <alan-jenkins@tuffmail.co.uk> wrote:

> > I think it's a B device.
> >
> > phy0: hwaddr 00:1b:2f:76:02:bc, RTL8187vB (default) V1
> + rtl8225z2

> That is an RTL8187L, rev. B. It is not an RTL8187B.

Yes, that's the (older) non-B device. B devices says RTL8187Bv{B,D,E} .=
 with a B before the 7; I have a rev E .The B device and the non-B devi=
ce while similiar enough to share some driver code, are different enoug=
h that
they might suspend/resume differently - they do probe/init slightly dif=
ferently. Besides, I think all the people who recently worked on that c=
ode are B-device owners, with maybe Larry who probably owns both types =
(or a few).

Hin-Tak


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
