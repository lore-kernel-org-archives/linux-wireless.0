Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:36940 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3BVKvm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 05:51:42 -0500
Received: by mail-lb0-f173.google.com with SMTP id gf7so470983lbb.32
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 02:51:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201302191842.01143.chunkeey@googlemail.com>
References: <CACNBsWgOu3xFS+kV7-C5rWW0hvTtVgweCJpmacppKWwU7mpREQ@mail.gmail.com>
 <201302182112.03235.chunkeey@googlemail.com> <CACNBsWjJyCoHmtNXHgGft4PuCJ3gbAmnjNJC6Zvr8+vj7cR-6g@mail.gmail.com>
 <201302191842.01143.chunkeey@googlemail.com>
From: Markus Ulfberg <jag@markusulfberg.se>
Date: Fri, 22 Feb 2013 11:51:18 +0100
Message-ID: <CACNBsWit=-hHr5ntPSN2t2xVOO6MaiF38qcAUqKDnNmKiTiy6g@mail.gmail.com> (sfid-20130222_115146_598248_4363A969)
Subject: Re: Prism54 issues after kernel upgrade
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

Please excuse my behaviour I'm not too familiar with mailing lists so
I missed that one.

Anyways the issues I had using firmware 2.7.0.0 came within minutes
after connection was established with an access point.

As far as things go the new firmware seems to work just fine. But I've
had a bit setback with my system in other areas so focus hasn't been
on testing the compat drivers as you mentioned. As soon as I get
things in order I will and post the results here.

Thanks again for the help.
Markus Ulfberg


On Tue, Feb 19, 2013 at 6:42 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> (no mailing-list cc?)
>
> Hello Markus,
>
> On Tuesday, February 19, 2013 06:14:29 PM Markus Ulfberg wrote:
>> As you suspected I had the old firmware 2.7.0.0 and after
>> I updated to the latest I'm no longer experiencing any
>> problems.
> Ok... If you can, do you have any numbers? I'm especially
> interested in: How often did you get these connection drops
> before? (I.e.: about every 10 minutes... or every day?)
>
>> Would you still like me to try the new driver aswell?
> The thing with a new compat-drivers p54pci is: Once you
> do, you'll probably also want to update your user-space
> applications as well (wpa_supplicant or hostapd).
>
> However, since 2.6.32 p54pci received a few bug fixes:
> <https://bugzilla.kernel.org/show_bug.cgi?id=11386>
> <https://bugzilla.redhat.com/show_bug.cgi?id=583623>
> which might or might not be in your Debian kernel.
>
> it also received a few new features:
> 1. "p54: connect to 11w protected networks"
>         <http://comments.gmane.org/gmane.linux.kernel.wireless.general/97035>
> 2. "p54: improve site survey"
>         <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/75502>
> 3. "p54: implement multicast filter"
>         <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/68642>
> 4. "p54: implement set_coverage_class"
>          <http://permalink.gmane.org/gmane.linux.kernel.wireless.general/65382>
> 5...
>
> Furthermore, there's another patch in the pipeline:
> "p54: do automatic device restart"
> <http://www.spinics.net/lists/linux-wireless/msg103532.html>
>
> So, you might not get the best experience. Of course, if
> it works and you like it then keep it the way it is ;).
>
>> Thank you ever so much for the quick reply and help.
>>
>> Have a great evening!
> You too! :)
>
> Regards,
>         Christian
