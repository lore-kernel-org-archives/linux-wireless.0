Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:56361 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031551AbeBNWMz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 17:12:55 -0500
Received: from [10.0.7.2] (worklap.sieb.net [10.0.7.2])
        by gw.sieb.net (Postfix) with ESMTPSA id 0BB692149A
        for <linux-wireless@vger.kernel.org>; Wed, 14 Feb 2018 14:04:46 -0800 (PST)
Subject: Re: Max clients on wifi access point with 7265
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <HE1PR0501MB23969FCE58F1EE7634D412F0F6F50@HE1PR0501MB2396.eurprd05.prod.outlook.com>
 <1518607856.21268.3.camel@sipsolutions.net>
From: Samuel Sieb <samuel@sieb.net>
Message-ID: <4f048d04-5f25-caa1-51b3-dcb14baf36da@sieb.net> (sfid-20180214_231259_285834_62D716E2)
Date: Wed, 14 Feb 2018 14:04:45 -0800
MIME-Version: 1.0
In-Reply-To: <1518607856.21268.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2018 03:30 AM, Johannes Berg wrote:
> On Wed, 2018-02-14 at 10:55 +0000, Mickaël PANNEQUIN wrote:
>   
>> Do you know the limit of the number of users connected at the same
>> time on the wifi? Works fine with 14 connected devices but not more.
>>
>> How to increase it?
> 
> You can't.
> 
>> This limit is hardware?
> 
> More or less, yes. The HW/FW can support 16 STAs, but needs two for
> other bookkeeping.

As a general question, is there a standard way to determine this limit 
for any particular hardware?
