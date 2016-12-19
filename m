Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754973AbcLSK6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:58:21 -0500
Subject: Re: cfg80211: add set/get link loss profile
To: Kalle Valo <kvalo@codeaurora.org>
References: <7742335b-f05e-edcd-ad80-fd09fb295eab@codeaurora.org>
 <8737izqw0q.fsf@purkki.adurom.net>
 <b1ab1406-d996-fc03-d0a2-b8028c7c0044@codeaurora.org>
 <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        wil6210@qca.qualcomm.com
From: "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org>
Message-ID: <32bed3e2-351e-ee01-5ddd-ccc5bd1aeebc@codeaurora.org> (sfid-20161219_115925_099711_A4F449E8)
Date: Mon, 19 Dec 2016 12:58:17 +0200
MIME-Version: 1.0
In-Reply-To: <8737ipm4jy.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2016 1:05 PM, Kalle Valo wrote:
> Hi Alexei,
> 
> "Lazar, Alexei Avshalom" <ailizaro@codeaurora.org> writes:
> 
>> In this context the term "link" does mean connection to AP. There are
>> scenarios that require to lose connection faster once reduced link
>> quality detected in order maintain better user experience (from both
>> sides - AP and STA). Example case is FST (Fast Session Transfer),
>> where we have a fast 11ad connection but close-range and a backup 11ac
>> connection which is "always on". in such cases if we detect poor link
>> quality in the active band we prefer to disconnect and switch to the
>> backup connection with the good link quality. This will be reached by
>> setting "aggressive" profile that will cause more rapid disconnect in
>> such cases.
> 
> The documentation should clearly document what this command is supposed,
> currently it only tells me "maintain/lose link" and does not specify in
> detail what this is supposed to do. Also there's no mention in what
> modes this can be used. (STA, P2P?)
> 

Ok I will send a new patch with updated description.

> Also please refrain from top posting in public mailing lists, the
> preferred way is to edit quotes and bottom post. It's much more natural
> way to have long detailed discussions.
> 

Sorry for that, I will refrain from top posting.

-- 
Alexei Lazar
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc. 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum a Linux Foundation Collaborative Project
