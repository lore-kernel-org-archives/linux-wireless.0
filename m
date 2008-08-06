Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:37273 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757102AbYHFQQI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 12:16:08 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1KQlgB-0005fn-Lr
	for linux-wireless@vger.kernel.org; Wed, 06 Aug 2008 16:16:03 +0000
Received: from gimpelevich.san-francisco.ca.us ([66.218.54.163])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 16:16:03 +0000
Received: from daniel by gimpelevich.san-francisco.ca.us with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 16:16:03 +0000
To: linux-wireless@vger.kernel.org
From: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
Subject: Re: Are these Ralink chips supported?
Date: Wed, 6 Aug 2008 16:15:53 +0000 (UTC)
Message-ID: <g7cinp$g4u$1@ger.gmane.org> (sfid-20080806_181613_352166_EBF5BE8B)
References: <20080805163234.GA22429@storm.local.network>
	<200808061014.10483.IvDoorn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 06 Aug 2008 10:14:10 +0200, Ivo van Doorn wrote:

> On Tuesday 05 August 2008, Forest Bond wrote:
>> Hi,
>> 
>> I'm having a hard time figuring out if the following wireless chips are
>> supported:
>> 
>>  * RT2770 + RT2720
> 
> I *think* this is the rt2870 driver. The in-kernel driver is under
> development

That is indeed rt2800usb. I don't have any rt2800usb hardware myself yet, 
but I would like to test rt2800pci when testable code is available. Any 
ETA?

