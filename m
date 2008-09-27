Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:42912 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbYI0VUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 17:20:23 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1603229wfd.4
        for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 14:20:21 -0700 (PDT)
Message-ID: <69e28c910809271420u1c14207bi672ecb5738ae6e15@mail.gmail.com> (sfid-20080927_232032_942457_C7248565)
Date: Sat, 27 Sep 2008 23:20:21 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: Paul <paul14075@gmail.com>
Subject: Re: [PATCH] Working packet injection patch for ipw2200 - enables aireplay-ng and others to work
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <7d553cf40809271345n3a945091u6c341e65c51811d5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 27, 2008 at 10:45 PM, Paul <paul14075@gmail.com> wrote:
> I made this patch using bits and pieces from various other "ipw2200
> injection patches".  I can not take credit for the content, as I
> basically just changed the line numbers in the .diff files.  However =
I
> applied this patch to the version of ipw2200 included in kernel
> 2.6.27-rc6  (i believe it's ipw2200-1.2.2) and it worked like a charm=
=2E
>
> Previously I was unable to inject wifi packets using aireplay-ng due
> to this error:
>
> "ARP linktype is set to 1 (Ethernet) - expected ARPHRD_IEEE80211 or
> ARPHRD_IEEE80211_PRISM instead.  Make sure RFMON is enabled: run
> 'ifconfig wifi0 up; iwconfig wifi0 mode Monitor channel <#>' Sysfs
> injection support was not found either."
>
> However, after switching to Monitor mode, even though aireplay would
> ACT AS IF it was working, it wasn't.
>
> After applying this patch, everything worked great.
>
> I don't see why this patch isnt already included in ipw2200.
>
> Thanks,
> - Paul
>

This is not a proper packet injection support patch - it is a rather
dirty hack. Please don't submit such patches to linux-wireless.
Also, when submitting patches, avoid whitespace-damage (the best way
to do this in Gmail is to attach the patch as a file *and* add it
inline, with a warning that the attached version should be applied,
not the inline one) and always include a Signed-off-by: line.

--G=E1bor

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
