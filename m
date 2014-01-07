Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59247 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaAGSkK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 13:40:10 -0500
Received: by mail-wg0-f45.google.com with SMTP id y10so521012wgg.24
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jan 2014 10:40:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52CC4799.4080806@candelatech.com>
References: <CAAVw_ZERCJhy4-Qczn36_CywE6_ceRc03BHfpvavn=A=xo=qRA@mail.gmail.com>
 <52CC4799.4080806@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 8 Jan 2014 00:09:49 +0530
Message-ID: <CABPxzYLUmq1sUKDX=sN6YbTfvXem53soy+b7kL4DSytW2+J9fg@mail.gmail.com> (sfid-20140107_194015_216002_4C3368A6)
Subject: Re: Virtual Network Interface
To: Ben Greear <greearb@candelatech.com>
Cc: Duy Tai Nguyen <duytai.cse@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 7, 2014 at 11:59 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 01/07/2014 05:24 AM, Duy Tai Nguyen wrote:
>> Dir sir!
>> I'm a student of University of Technology HCMC, When I find whether
>> Android is able to support virtual network interface (vif) like vif in
>> linux (wireless.kernel.org/en/users/Documentation/iw/vif/)
>> I am wondering if you can help me explain some questions below.
>> 1. does android kernel support virtual network interface (vif)?
>> 2. does 802.11 standard consist of vif?
>> 3. does all WiFi cards support vif or only some of them?
>
> The android phone I looked at briefly was running an Atheros
> based NIC, but it did not support more than one station VIF.
>
> Possibly other systems can do more, but I think it is not
> very likely.
>
> In general, if you want multiple stations vifs, you need
> ath9k, and for more than just a few stations, you need a
> pci or pci-e based NIC (not USB).
>
> Ath5k might work in some cases, and with proper firmware and
> some driver tweaks, ath10k should support some as well.
>
> Thanks,
> Ben
>
>
Adding to that, its not a question of android supports or not, rather
your wifi chipset supports or not. iw (if its available will give info
of the NIC capabilities).

VIF is a implementation term, no the 802.11 standard concept.

My phone has a qualcomm WCN chipset which does support multiple
VIF's, one for STA, SoftAP, P2P etc..

Once you have rooted the phone you can use the same commands
as desktop linux and play around with the VIF's.
