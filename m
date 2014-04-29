Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaD2PnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 11:43:22 -0400
Received: by mail-ob0-f174.google.com with SMTP id gq1so447480obb.5
        for <linux-wireless@vger.kernel.org>; Tue, 29 Apr 2014 08:43:22 -0700 (PDT)
Message-ID: <535FC896.1080604@lwfinger.net> (sfid-20140429_174326_223966_0B31F1BA)
Date: Tue, 29 Apr 2014 10:43:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sven Eckelmann <sven@narfation.org>
CC: Tim Gardner <rtg.canonical@gmail.com>,
	Nicolas Vaquero <nicovaq92@hotmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel source
References: <535E7741.1030607@lwfinger.net> <3262959.TlL8alHHte@bentobox>
In-Reply-To: <3262959.TlL8alHHte@bentobox>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2014 02:42 AM, Sven Eckelmann wrote:
> On Monday 28 April 2014 10:44:01 Larry Finger wrote:
> [...]
>> Is there a link to the 3.8.0-37 source? I could not find it on the Ubuntu
>> web pile. With it, I should be able to fix his problem as long as I can
>> duplicate it.
>
> Which exact versions? 3.8.0-36.52~precise1 and 3.8.0-37.53~precise1? There were
> a lot of backports which you can find all here:
> https://launchpad.net/ubuntu/+source/linux-lts-raring/+publishinghistory
>
> You can just click on the version number at the right to find the *.tar.gz,
> *.diff.gz and *.dsc.
>
> You can download and create a source directory using
>
> dget https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-36.52~precise1/+files/linux-lts-raring_3.8.0-36.52~precise1.dsc
> or
> dget https://launchpad.net/ubuntu/precise/+source/linux-lts-raring/3.8.0-37.53~precise1/+files/linux-lts-raring_3.8.0-37.53~precise1.dsc

Sven,

Thanks for the info. I wanted version 3.8.0-37.53~precise1, but given that the 
code is available as the original source and the diff, I also grabbed the diff 
file for 3.8.0-36.52~precise1. My test kernel is building now.

Larry


