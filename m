Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:14747 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbYHZTTB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2008 15:19:01 -0400
Received: by nf-out-0910.google.com with SMTP id d3so990701nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2008 12:18:59 -0700 (PDT)
Message-ID: <f6ca9fed0808261218w20334033h7eef71dba8400ac8@mail.gmail.com> (sfid-20080826_211907_692401_95D31B98)
Date: Tue, 26 Aug 2008 21:18:59 +0200
From: drago01 <drago01@gmail.com>
To: "Forest Bond" <forest@alittletooquiet.net>
Subject: Re: Are these Ralink chips supported?
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080826191654.GB26037@storm.local.network>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080805163234.GA22429@storm.local.network>
	 <200808061014.10483.IvDoorn@gmail.com>
	 <20080826191654.GB26037@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 26, 2008 at 9:16 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi,
>
> On Wed, Aug 06, 2008 at 10:14:10AM +0200, Ivo van Doorn wrote:
>> On Tuesday 05 August 2008, Forest Bond wrote:
>> > I'm having a hard time figuring out if the following wireless chips are
>> > supported:
>> >
>> >  * RT2770 + RT2720
>>
>> I *think* this is the rt2870 driver. The in-kernel driver is under development
>
> Okay, the RT2870 driver from Ralink works with this device, but it seems to be a
> bit quirky:
>
>  * The device has to be brought up and down a few times before NetworkManager
>   sees it.  I'm not sure what NetworkManager is cueing off of.
>
>  * I was unable to get the thing to associate and come up using
>   iwconfig/ifconfig.  Might have been my range on that AP, though, since I was
>   shooting for an unencrypted network that is a not the closest network in my
>   building.
>
>  * Usual odd bits with vendor drivers like odd build system subtleties and
>   seemingly unnecessary configuration files (does anyone really care to fiddle
>   with those, or doesn't everyone just want things to work with the standard
>   configuration mechanisms like I do?).
>
> Is there an effort to move this driver in-tree?  The license is GPL.

Thats what Ivo is doing, port the driver to rt2x00 to make it
acceptable for merging.
