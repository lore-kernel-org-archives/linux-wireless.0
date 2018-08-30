Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr60081.outbound.protection.outlook.com ([40.107.6.81]:26400
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727106AbeHaDaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 23:30:00 -0400
Subject: Re: [PATCH v2 2/2] ath10k: Set sk_pacing_shift to 6 for 11AC WiFi
 chips
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Wen Gong <wgong@qti.qualcomm.com>,
        Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1533724802-30944-1-git-send-email-wgong@codeaurora.org>
 <1533724802-30944-3-git-send-email-wgong@codeaurora.org>
 <87sh3pdtpg.fsf@toke.dk>
 <f185ab8722e84c959b375e606d25a29b@aptaiexm02f.ap.qualcomm.com>
 <87mutue4y8.fsf@toke.dk>
 <ef7b317006964c0fa72763bbfc5149e5@aptaiexm02f.ap.qualcomm.com>
 <87600eecr7.fsf@toke.dk>
 <68d91488f58f4a449908fc7eeebb8b34@aptaiexm02f.ap.qualcomm.com>
 <87tvntb53x.fsf@toke.dk>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <ae8d9891-b827-7ca5-1375-0280d8f5c194@bowerswilkins.com> (sfid-20180831_012530_200495_EB66D0FA)
Date: Thu, 30 Aug 2018 16:25:11 -0700
MIME-Version: 1.0
In-Reply-To: <87tvntb53x.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Toke,


On 08/17/2018 04:32 AM, Toke Høiland-Jørgensen wrote:
>
>>>> Shift 6:
>>>> wgong@wgong-Latitude-E5440-1:~/flent$ flent -H 192.168.1.7 -t
>>>> "sk_pacing_shift6" tcp_nup --test-parameter upload_streams=1
>>>
Does flent have options to set TOS or QoS queue for TCP or UDP test?
If I add "--test-paramete burst_tos=0xe0", will it use corresponding 
mac80211 QoS queue?
flent -H xxxx -t "xxxx" tcp_nup --test-parameter upload_streams=1 
--test-paramete burst_tos=0xe0

Thanks,
Peter
