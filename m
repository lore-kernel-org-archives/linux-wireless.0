Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:49076 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbZJRTzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2009 15:55:03 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1877468fgg.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2009 12:55:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4ADB5334.3070109@linuxlighthouse.com>
References: <4ADB5334.3070109@linuxlighthouse.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 18 Oct 2009 21:54:47 +0200
Message-ID: <69e28c910910181254h71a80b6q488d1eb8bd8fbd6f@mail.gmail.com>
Subject: Re: moblin, rt2860, and unhappiness
To: jack craig <jackc@linuxlighthouse.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 18, 2009 at 7:41 PM, jack craig <jackc@linuxlighthouse.com> wrote:
> Hi linux-wireless,
>
> This is my first posting, so please pardon me if I break any rule.
>
> A bit a background, last spring in a bout of unemployment, i wanted to find
> a new development direction.
>
> i had been working with a company providing wireless products (Danger), and
> wanted to continue that
> direction using  mobile linux as a platform.
>
> I subscribed to the moblin developers list, bought an Asus EeePC 1000 with
> xandros installed and began
> my development project.
>
> I chose to keep the xandros os in the netbook as its wireless was the first
> working wireless
> i've had. i booted the various moblin pre-beta releases via the thumbdrive
> and wasnt too
> worried when the wireless didnt work on the moblin os; after all it was
> pre-beta.
>
> as the xandros wireless worked, i felt confident that the good folks at
> Intel would make my netbook
> wireless work by the time beta rolled around.
>
> it was my error in assuming an Intel cpu included a Intel wireless chipset,
> instead i found i had an rt2860.
>
> as beta came and went with still no wireless joy, i started probing deeper
> and found the ralink
> rt2860 support wasnt going to be covered in the moblin project work.
>
> so here i am with a netbook that cant get to the net with the os of my
> choice. Much unhappiness!
>
> i have learned that the driver source is available and i plan to track that
> down.
>
> i have also been toying with the idea of surgery; putting a Intel wireless
> chipset in the eeepc,
> but the only article I've found on that topic is a bit much for a software
> only geek.

Actually, it's not tricky at all - you will need to get an Intel
3945/4965/5100/5150/5300/5350 PCI-Express Mini Card (or Half-Mini Card
if your Eee PC has that one - compare the card in your system with the
cards on http://embeddedsystemnews.com/images/embedded/pciexpressminihalfminicards.jpg),
and swap the Ralink card in your machine with the Intel card. It
should be plug-and-play. (And it's not limited to Intel - you can use
any PCIE Mini Card.) You can find plenty of these cards on eBay, such
as http://cgi.ebay.com/ws/eBayISAPI.dll?ViewItem&item=250512964837.

>
> I like the eeepc and want to use it with wireless.
>
> i figure my best case is to find a way to get the ralink driver working with
> the moblin os,
> but at least one person has failed at that attempt to far.
>
> a fall back position is to go with a fedora os where i could get the driver
> working there
> (if it doesn't already).
>
> so, finally, my query to this august group; given this sob story, what is
> your wisdom on the topic?
>
> is my goal to get the rt2860 working on moblin a gesture in futility?
>
> does it make sense to bail and go on to FC? i use FC for my desktop and work
> so i prefer it over ubuntu ,...
>
> Suggestions? tia, jackc...
>
> --
>   jack craig
>      jackc@LinuxLightHouse.com
>         831-684-1375 (Office)
>            831-596-6924 (cell)
>               IM: jackcraigaptos (AIM)
> _________________________________
> This email has been ClamScanned !
>    www.LinuxLightHouse.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
