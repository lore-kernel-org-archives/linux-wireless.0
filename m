Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52812 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757636AbbGGVLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 17:11:21 -0400
Message-ID: <559C402B.3090004@codeaurora.org> (sfid-20150707_231126_263558_7DA62B34)
Date: Tue, 07 Jul 2015 14:10:03 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: CACook@quantum-sci.com, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org, Peter Oh <poh@qca.qualcomm.com>
Subject: Re: [PATCH 3/3] ath10k: add support for qca99x0 Rx descriptors
References: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com> <1436287676-25767-4-git-send-email-poh@qca.qualcomm.com> <2345251.lpvZM96hbt@andromeda>
In-Reply-To: <2345251.lpvZM96hbt@andromeda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 07/07/2015 10:09 AM, CACook@quantum-sci.com wrote:
> On Tuesday 07 July 2015 9:47:56 Peter Oh wrote:
>> QCA99X0 chip has an extra 4 bytes in rx_msdu_start,
>> 20 bytes in rx_msdu_end and 20 bytes in rx_ppdu_end structure
>> which are used in htt_rx_desc and HTT Rx ring offset setup.
>> This is necessary for correct Rx for QCA99X0 or Rx descriptors
>> will be overwritten and corrupted.
> Will this be in the most recent git,
Yes. this patch set is based on top of most recent git.
>   to support the QCA9880?
QCA9880 is already supported and this patch set is to support QCA99X0.
>
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Thanks,
Peter
