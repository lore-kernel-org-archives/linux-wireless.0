Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:52084 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbHJE0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2015 00:26:47 -0400
Date: Mon, 10 Aug 2015 14:19:57 +1000
From: James Cameron <quozl@laptop.org>
To: AceLan Kao <acelan.kao@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8723be: disable FW control power save
Message-ID: <20150810041957.GA7681@us.netrek.org> (sfid-20150810_062702_565452_0808A06C)
References: <1438917073-5720-1-git-send-email-acelan.kao@canonical.com>
 <55C4DDF5.6010901@lwfinger.net>
 <CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFv23Qk285G47pPVrfUn5izfZyrc-vCSPqJamnoxQMm6Ae9zpQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 10, 2015 at 11:38:09AM +0800, AceLan Kao wrote:
> I tried using "ips=0" today and found it's not working.
> I ping 8.8.8.8 and got below message within one hour.
>    ping: sendmsg: No buffer space available

I use both ips=0 and fwlps=0 with Ubuntu kernel and with 4.1, and the
connection remains stable.

fwlps=0 alone was not enough.

ips=0 alone was not enough.

Hope that helps.

-- 
James Cameron
http://quozl.linux.org.au/
