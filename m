Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:15810 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750883Ab0FCEwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 00:52:20 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-020323736
	for <linux-wireless@vger.kernel.org>; Thu,  3 Jun 2010 13:52:18 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ray <raystinger@gmail.com>
Subject: Re: [ath5k-devel] New developer to linux and ath5k, request for assistance :)
Date: Thu, 3 Jun 2010 13:52:59 +0900
References: <F2E5E871-ED3F-42DB-A34B-3C9B46233F9F@gmail.com>
In-Reply-To: <F2E5E871-ED3F-42DB-A34B-3C9B46233F9F@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006031352.59759.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 June 2010 11:43:47 Ray wrote:
> Hi fellow developers,
> 
> I have just started to look into Linux and would like to get my hands dirty
> with the ATH5k development.
> 
> As of now, I have installed Ubuntu LTS 10.04 and some software packages I
> believe would be necessary for development (i.e. Build-essentials,
> linux-libc-dev and linux-source-2.6.32). The next step I suppose is to
> download the ATH5k source and start to look into the codes. But I have
> several questions in mind and would appreciate if some of you can shed me
> some light and point me to the right direction.
> 
> I understand that this version is Ubuntu already comes with ATH5k installed
> by default. My understanding is that I have to first disable it and then
> download the ATH5K source off the internet and work on the downloaded copy
> instead. In that case, may I know how can I unload the default ATH5K from
> Ubuntu? I tried using the blacklist method as suggested by some folks in a
> forum but I am wondering if that will effectively blacklist my home-brewed
> ATH5K as a result subsequently.
> 
> Lastly, may I know if theres any online guide on how do I get started with
> ATH5K development for a new developer who has little Linux experience? I'm
> a relatively quick learner, so if theres an online guide somewhere, I
> should be able to follow it through and hopefully get up to speed quickly.
> 
> Thanks for reading and I appreciate all the help I can get. Cheers! :)

hi simon!

we can definetly need some help with ath5k... :)

the best way to work on ath5k is to compile your own kernel based on the 
wirless-testing git tree. this is where all wireless drivers are developed and 
using it you can make sure you get all latest changes to mac80211 (the driver 
independet mac-layer part) and ath5k. just compile the kernel, install it and 
boot into it. you can use the ubuntu kernel configuration 
(/boot/config-2.6.32-22-generic) as a start for your kernel, but you can 
disable a lot of drivers and optimize it quite a bit to have faster compile 
times (and better optimization for your machine).

a good start to read is:
http://wireless.kernel.org/en/developers/Documentation
http://wireless.kernel.org/en/users/Drivers/ath5k

if you have any more questions, feel free to ask... 

bruno
