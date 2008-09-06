Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:12493 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYIFQhM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Sep 2008 12:37:12 -0400
Received: by wf-out-1314.google.com with SMTP id 27so905083wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 06 Sep 2008 09:37:11 -0700 (PDT)
Message-ID: <69e28c910809060937h5d484f4fsdfe93c350d78c28d@mail.gmail.com> (sfid-20080906_183718_056078_B65A1B9C)
Date: Sat, 6 Sep 2008 18:37:11 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Greg White" <pcguy11@live.com>
Subject: Re: rt2x00 and packet injection
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY118-W272ED23066D58EE95965A6DB5B0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <BAY118-W272ED23066D58EE95965A6DB5B0@phx.gbl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 6, 2008 at 2:34 AM, Greg White <pcguy11@live.com> wrote:
>
> Hi,
>
> What is the status of packet injection in the rt2x00 driver?  From my testing of 2.6.27 rc3 and reading 2.6.27 doesn't seem likely.  Is there a todo list in priority order?
>
> Thanks,
>

I don't know about other sub-drivers, but rt73usb has no problems with
packet injection whatsoever. As with all other mac80211-based drivers,
an injector application with Radiotap header support is required.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
