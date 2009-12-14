Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from scl-exch2k.phoenix.com ([134.122.225.253]:14891 "EHLO
	scl-exch2k.phoenix.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbZLNRpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 12:45:52 -0500
From: Satanand Burla <Satanand_Burla@phoenix.com>
To: Kalle Valo <kalle.valo@iki.fi>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 14 Dec 2009 09:45:44 -0800
Subject: RE: ath9k ps poll performance
Message-ID: <6D80BDFB1A1FA74DA476417C24C452A10251AB581D@scl-exch2k7.phoenix.com>
References: <6D80BDFB1A1FA74DA476417C24C452A10251AB5773@scl-exch2k7.phoenix.com>
 <871viy13of.fsf@purkki.valot.fi>
In-Reply-To: <871viy13of.fsf@purkki.valot.fi>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>Satanand Burla <Satanand_Burla@phoenix.com> writes:
>
>> for example with the same wep AP, I get around 150 to 200 Kbps
>> without enabling ps poll.
>
>That's very low. What kind of test are you using here?

Just an ftp from kernel.org.
>
>> but if I enable ps poll with the above settings, I get only around
>> 20 Kbps and the packet loss is around 20 to 30%.
>>
>> My question is, is this the expected speed drop when turning on ps
>> poll ? Or is this a problem with the driver that still needs to be
>> addressed ?
>
>With PS-Poll (ie. timeout is zero) you should still get in range of
>megabits per second and no packet loss. So something is wrong.
>
Thank you.

Satanand.
