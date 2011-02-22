Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43221 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1BVFpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Feb 2011 00:45:44 -0500
Message-ID: <4D634D7D.2090904@candelatech.com>
Date: Mon, 21 Feb 2011 21:45:33 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: Sujith <m.sujith@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 19/23] ath9k_htc: Handle BSSID/AID for multiple interfaces
References: <19809.52184.289748.148298@gargle.gargle.HOWL> <20110222053749.GB11916@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110222053749.GB11916@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2011 09:37 PM, Rajkumar Manoharan wrote:
> On Mon, Feb 21, 2011 at 07:50:08AM +0530, Sujith wrote:
>> From: Sujith Manoharan<Sujith.Manoharan@atheros.com>
>>
>> The AID and BSSID should be set in the HW only for the
>> first station interface or adhoc interface. Also, cancel
>> the ANI timer in stop() for multi-STA scenario. And finally
>> configure the HW beacon timers only for the first station
>> interface.

Didn't we fix all of this in ath9k by counting the various
interface types and dynamically setting the opmode,
etc properly?

Can't we re-use that code for htc?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
