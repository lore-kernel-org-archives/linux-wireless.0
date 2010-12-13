Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from router-304.cs.umd.edu ([128.8.127.145]:4306 "EHLO
	sausage.cs.umd.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755347Ab0LMU3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 15:29:06 -0500
Message-ID: <a31a76030a2d5aa4578500d648863293.squirrel@webmail.cs.umd.edu>
In-Reply-To: <016c01cb9afe$27bd5000$7737f000$@gmx.net>
References: <2518B44B-D014-4ABA-AE31-BD75691488AB@ing.unibs.it>
    <1DBB75B1-733F-4DFC-A541-2C2C986586A6@ing.unibs.it>
    <AANLkTika70YCWU8eG5QHO+Bdf5XakEOg_b+UJdgCG4A0@mail.gmail.com>
    <E338C554-ADF5-490D-825D-E04D295664F0@ing.unibs.it>
    <AANLkTimUdX1duphd=QYRz_i-TERfXbjOM1QEXaTUO13M@mail.gmail.com>
    <016c01cb9afe$27bd5000$7737f000$@gmx.net>
Date: Mon, 13 Dec 2010 14:53:34 -0500
Subject: Re: AW: Release of Maranello firmware source code for Broadcom
 cards
From: "Bo Han" <bohan@cs.umd.edu>
To: "h2o-post" <h2o-post@gmx.net>
Cc: "=?iso-8859-1?Q?=22'Rafa=C5=82_Mi=C5=82ecki'=22?=" <zajec5@gmail.com>,
	francesco.gringoli@ing.unibs.it,
	"'linux-wireless'" <linux-wireless@vger.kernel.org>,
	b43-dev@lists.infradead.org, "'Bo Han'" <bohan@cs.umd.edu>
Reply-To: "Bo Han" <bohan@cs.umd.edu>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

As Francesco said in the previous email, the source code of Maranello,
including both firmware and kernel patches, is now available at

http://www.cs.umd.edu/projects/maranello/

Feel free to give it a try and let us know if you have any problems.

Thanks,
-Bo

On Mon, December 13, 2010 2:44 pm, h2o-post wrote:
> Hi Francesco,
>
> We are running a mesh network with 45 nodes all by Linksys wrt54g routers
> in our village to get somehow internet connectivity.
> As I saw your maranello paper  I am curious to test your Broadcom firmware
> in our productive net.
> Is the firmware already available that supports this kind of crc frame
> checking ?
>
> Regards Thomas
>
> -----Ursprüngliche Nachricht-----
> Von: b43-dev-bounces@lists.infradead.org
> [mailto:b43-dev-bounces@lists.infradead.org] Im Auftrag von Rafal Milecki
> Gesendet: Sonntag, 10. Oktober 2010 19:36
> An: francesco.gringoli@ing.unibs.it
> Cc: linux-wireless; b43-dev@lists.infradead.org; Bo Han
> Betreff: Re: Release of Maranello firmware source code for Broadcom cards
>
> W dniu 10 października 2010 18:53 użytkownik
> <francesco.gringoli@ing.unibs.it> napisał:
>> On Oct 10, 2010, at 4:47 PM, Rafał Miłecki wrote:
>>
>>> 2010/10/10  <francesco.gringoli@ing.unibs.it>:
>>>> Hello there,
>>>>
>>>> we released the source code of the Maranello firmware and all the
>>>> necessary kernel patches. It was tested on Broadcom 4318/4306 pci
>>>> cards on PC architecture. Find all the necessary files browsing from
>>>>
>>>> http://www.ing.unibs.it/openfwwf
>>>>
>>>> or go directly here
>>>>
>>>> http://www.cs.umd.edu/projects/maranello
>>>>
>>>>
>>>> Maranello is an enhancement of the 802.11 DCF standard: it
>>>> implements a Partial Packet Recovery technique to retransmit only
>>>> the corrupt parts of failed packets. This reduces the airtime and
>>>> contributes to enhance the throughput. It was written starting from
>>>> OpenFWWF5.2 by adding a number of new features.
>>>>
>>> Did you just add recovery feature to OpenFWWF 5.2 or did you improve
>>> basic OpenFWWF as well?
>>>
>>> My 4318 with OpenFWWF 5.2 stops transmitting after few MB. Can
>>> Maranello contain any fix for this? I'll able to test this later next
>>> week.
>>
>> No, I don't think so. OpenFWWF5.2 does not handle correctly fifo
>> overflow conditions. We have a testing firmware that handles them (and
>> that works perfectly on WRT54GL): I hope we can release it soon.
>
> Wow, that's great! If you need more testing, I'm willing to do some.
> If you need full root access to machine with 4318 running
> wireless-testing, just mail me privately.
>
> Really hope you will manage to release that soon :)
>
> --
> Rafał
>
> _______________________________________________
> b43-dev mailing list
> b43-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/b43-dev
>
>


