Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751281AbeDVMkf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 08:40:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 22 Apr 2018 15:40:34 +0300
From: merez@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [02/10] wil6210: set/get EDMG channel through debugfs
In-Reply-To: <20180419161506.868FA60A06@smtp.codeaurora.org>
References: <1523520526-24997-3-git-send-email-merez@codeaurora.org>
 <20180419161506.868FA60A06@smtp.codeaurora.org>
Message-ID: <bf89143fe2765fab1aad65b9587030bf@codeaurora.org> (sfid-20180422_144039_805367_D8ABB0C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-19 19:15, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> wrote:
> 
>> Setting EDMG channel through debugfs for connect and PCP start
>> commands.
> 
> Why? And what is an EDMG channel?
> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why
> 
> I get bad vibes that this debugfs file is just a workaround for not 
> adding this
> to nl80211, a proper commit log would not give me such vibes in the
> first place :)

EDMG (Enhanced Directional Multi-Gigabit) is a new feature, part of 
11ad/11ay specification.
In a nutshell it allows channel bonding of 60Ghz channels.

The debugfs is used for debug-only to allow forcing a channel, not 
intended to replace NL API,
which we are working to upstream such.

I'll send a new version with fixed commit text.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
