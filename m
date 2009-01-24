Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f10.google.com ([209.85.219.10]:59159 "EHLO
	mail-ew0-f10.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZAXLrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 06:47:13 -0500
Received: by ewy3 with SMTP id 3so97335ewy.13
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 03:47:11 -0800 (PST)
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Message-Id: <467E98EC-F5B1-4D79-914E-35E021125E37@icix.org> (sfid-20090124_124729_126540_9E9080BA)
From: =?ISO-8859-1?Q?Ant=F3nio_Marques?= <froz@icix.org>
To: Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <45e8e6c40901231102y732b6929sce70b00ffcd8bef5@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: rt2x00 mesh support
Date: Sat, 24 Jan 2009 11:40:22 +0000
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <45e8e6c40901231102y732b6929sce70b00ffcd8bef5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok. I didn't realize the driver was broken and the issue wasn't specific
to mesh support. I hope the driver maintainers can solve this soon.

Thanks,
Antonio Marques

On Jan 23, 2009, at 19:02 , Andrey Yurovsky wrote:
> Hi Antonio.  As I understand it, beaconing is currently broken in
> rt2x00 (it used to work in the past).  This means that, until the
> device can send beacons again, it won't be able to do mesh (or AP or
> IBSS).  However the commit in question at least sets up the driver to
> support mesh as soon as beaconing works again.
>
> On Fri, Jan 23, 2009 at 10:58 AM, Antonio Marques <froz@icix.org>  
> wrote:
>> Hi,
>>
>> I have been trying to setup a mesh network using the 802.11s stack,  
>> but
>> unfortunately the only hardware that I have readily available are  
>> rt2x00
>> usb dongles and an ath5k mini-pci card. Since support for rt2x00
>> driver is listed on o11s.org as being in development, what is the  
>> current
>> status
>> of mesh support for this driver?
>>
>> I see recent commit activity such as
>> fdc26201323eb8ba543ac5624f8d71e55b6f7352,
>> "rt2x00: Add mesh support" but I am still unable to establish mesh  
>> links
>> using
>> rt2x00 devices. An rt2x00 device can see the ath5k device according  
>> to
>> 'iw dev mesh station dump', but the link state never changes to  
>> ESTAB.
>>
>> Thanks,
>> Antonio Marques
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

