Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:52228 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZHaVKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 17:10:52 -0400
Received: by fxm17 with SMTP id 17so3061918fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 14:10:53 -0700 (PDT)
Message-ID: <4A9C3C59.5010305@lwfinger.net>
Date: Mon, 31 Aug 2009 16:10:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tobias Schlemmer <keinstein_junior@gmx.net>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187b Problem with tx level
References: <h7eo7q$7ks$1@ger.gmane.org>	 <3ace41890908311055s5c49a25fjf69ca48024579d44@mail.gmail.com>	 <43e72e890908311102q2ed9e8b3q8f1f15d45a29b2f1@mail.gmail.com>	 <3ace41890908311132g16783b68y2d1771ce1d2780d@mail.gmail.com>	 <43e72e890908311141k6bcf5edbl6bce2b88670fb5f8@mail.gmail.com> <3ace41890908311157v4fbc9829j6db9c91ef6fff3c7@mail.gmail.com>
In-Reply-To: <3ace41890908311157v4fbc9829j6db9c91ef6fff3c7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> I just took a look at the history - there aren't obvious bug fixes, a
> bunch of work queue-related changes from you & Johannes; feature-wise,
> Larry added LED blinking after 2.6.30, and Herton added rfkill support
> quite recently after 2.6.31-rc7 . But no, there isn't any change that
> would affect tx level beyond 2.6.31-rc7, I think.

Your analysis matches my recollection.

Apparently RealTek is supplying a closed-source driver for RTL8187B
these days. There are no sources for the B on their web site. In
addition, the one that Tobias loaded tainted his kernel.

Larry

