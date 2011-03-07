Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30775 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab1CGFoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 00:44:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 21:43:58 -0800
Message-ID: <4D7470AF.7070800@atheros.com>
Date: Mon, 7 Mar 2011 11:14:15 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>,
	=?ISO-8859-1?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"stable@kernel.org" <stable@kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>
Subject: Re: [stable] [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <1297785572-27955-1-git-send-email-mshajakhan@atheros.com> <20110215161222.GD2557@tuxdriver.com> <4D5B5B02.4020101@atheros.com> <4D70816D.80304@atheros.com> <20110304133722.GA9866@tuxdriver.com> <20110304213713.GA31324@kroah.com>
In-Reply-To: <20110304213713.GA31324@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 March 2011 03:07 AM, Greg KH wrote:
> On Fri, Mar 04, 2011 at 08:37:23AM -0500, John W. Linville wrote:
>    
>> On Fri, Mar 04, 2011 at 11:36:37AM +0530, Mohammed Shafi wrote:
>>      
>>> On Wednesday 16 February 2011 10:35 AM, Mohammed Shafi wrote:
>>>        
>>>> On Tuesday 15 February 2011 09:42 PM, John W. Linville wrote:
>>>>          
>>>>> Despite the [RFC], I am applying this.  I should have reverted all
>>>>> of this three weeks ago...
>>>>>            
>>> John can you please push this to stable kernel ?
>>>        
>> Stable folks, this is the commit in Linus's tree;
>>
>> commit 0f5cd45960173ba5b36727decbb4a241cbd35ef9
>>      
> Too bad this commit doesn't apply to the .37-stable tree :(
>    
This is because of the commit 4dc3530df7c0428b41c00399a7ee8c929406d181.
And this is handled by the backport provided by Thomas.

thanks,
shafi
> Can someone provide stable@kernel.org a backported version of this?
>
> thanks,
>
> greg k-h
> .
>
>    
