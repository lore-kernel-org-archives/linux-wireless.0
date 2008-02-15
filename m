Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49602 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663AbYBOHHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 02:07:39 -0500
Message-ID: <20080215020738.7i4ba6miv4kk8cow@webmail.spamcop.net> (sfid-20080215_070741_927185_A3C3C135)
Date: Fri, 15 Feb 2008 02:07:38 -0500
From: Pavel Roskin <proski@gnu.org>
To: Mark Wallis <mwallis@serialmonkey.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: Both rt2500usb and rt73 claim USB device 148f:2573
References: <1203056096.30732.63.camel@dv>
	<DF448D07-5C48-43C0-B6DD-12AF17BE0943@serialmonkey.com>
In-Reply-To: <DF448D07-5C48-43C0-B6DD-12AF17BE0943@serialmonkey.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Mark Wallis <mwallis@serialmonkey.com>:

> Hi Pavel,
>
> On 15/02/2008, at 5:14 PM, Pavel Roskin wrote:
>
>> My Level One WNC-0301USB v3 has USB ID 148f:2573, which is listed as
>> compatible both in rt2500usb.c and rt73usb.c.  It only works with rt73
>> but not with rt2500usb.
>>
>> Is this duplication intentional?
>
> I'm afraid so. That particular manufacturer I believe changed the
> chipset they were using without updating their USD device ID's. We have
> seen this a few times now and the only solution we have been able to
> provide is to give the users instructions for blacklisting the
> incorrect driver.
>
> I believe this has been discussed on this list previously.

Thanks and sorry for the noise.

-- 
Regards,
Pavel Roskin
