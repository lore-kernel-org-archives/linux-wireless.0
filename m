Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tpi.com ([70.99.223.143]:3971 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0K3Vrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 16:47:43 -0500
Message-ID: <4CF56AB8.7040901@canonical.com>
Date: Tue, 30 Nov 2010 14:20:56 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: thomas@xyz.pp.se, linux-wireless@vger.kernel.org
Subject: Re: wireless.kernel.org update
References: <1291106122.13696.0.camel@thonov-ubuntu> <4CF54B97.40604@hauke-m.de>
In-Reply-To: <4CF54B97.40604@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/30/2010 12:08 PM, Hauke Mehrtens wrote:
> On 11/30/2010 09:35 AM, Thomas Novin wrote:
>> Hello
>>
>> This page,
>> http://wireless.kernel.org/en/users/Download#Getting_compat-wireless_on_Ubuntu, should be updated to include Maverick/10.10.
>>
>> If I just try to install as instructed for other versions:
>>
>> sudo apt-get install linux-backports-modules-wireless-lucid-generic
>>
>> I get:
>>
>> E: Unable to locate package
>> linux-backports-modules-wireless-lucid-generic
>
> I added the package names for Ubuntu 10.10 into the wiki. The Ubuntu
> guys changed the name of the package but the meta package is still
> depending on the old names, this is a Ubuntu bug. (see:
> https://bugs.launchpad.net/ubuntu/+source/linux-meta/+bug/681727 )
>
> Hauke
> --

Should have it fixed soon. It was a bit of a goof because we're going to 
offer multiple versions of the compat-wireless package which in turn 
required some package name changes.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
