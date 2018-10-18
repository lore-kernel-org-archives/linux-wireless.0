Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F104C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 05:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30031208E4
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 05:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dofUyI+g";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iS/GLaqv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30031208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbeJRNOZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 09:14:25 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40984 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbeJRNOZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 09:14:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B73046134E; Thu, 18 Oct 2018 05:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539839713;
        bh=mz203DNAXQ6UcBXWicIz0QFxn5wtcnjgNgrPlJNGSzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dofUyI+gy7GsN81UqvuoPcId41EZpcOfS5//GeC5UVfZauUXZ3qI0QYpm48fingLU
         +T+lzq0FRhckLjnWA5Scv8M5AUaYDddVTaHnv4LumrA8yWg15tf6K/B8JtXrCZLaQ2
         Oevx9HrdOrFj6NVcIEeD5iqnNJiXfiRLwv0dd0Ps=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 6BC2361364;
        Thu, 18 Oct 2018 05:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539839712;
        bh=mz203DNAXQ6UcBXWicIz0QFxn5wtcnjgNgrPlJNGSzY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iS/GLaqv6Fi0HpfHZOASLZWCesVM3/n5PevSyBVCW8fnLZ80B7io540akq9LHlhRr
         8c/WUUHyQAvbEWMgGdimhq3+3RjvLHwdgJngbr76Zf6yBuA7yXGwOaLIQNDZbVsppj
         QIKjSO4ut0y+WMrfond12vN7gAsHsh6yoDfmEv3U=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Oct 2018 08:15:12 +0300
From:   merez@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: wireless workshop
In-Reply-To: <1539080903.3687.111.camel@sipsolutions.net>
References: <6cab0b49-a6f3-65c5-f371-1f8c7d4325bb@mojatatu.com>
 (sfid-20180918_141228_189659_E18D74BF)
 <1539080903.3687.111.camel@sipsolutions.net>
Message-ID: <0dee57570571ce5de5becaa4a2873f0c@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-09 13:28, Johannes Berg wrote:
> Hi all,
> 
> On Tue, 2018-09-18 at 08:11 -0400, Jamal Hadi Salim wrote:
>> On behalf of the NetDev Society, this is a formal announcement that
>> Netdev 0x13 conference will be held in Prague, Czech Republic.
>> Tentative dates are March 20-22, 2019.
> 
> Kalle and I have (more or less) decided to propose a wireless workshop
> for Netdev 0x13.
> 
> In order to gauge interest and plan room size, can you reply (privately
> if you like) if this would work for you and you'd (want to) attend?
> 
> Thanks,
> johannes

Great initiative!
I would be happy to attend.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
