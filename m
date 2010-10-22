Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51246 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0JVRu1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 13:50:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 10:50:17 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 22 Oct 2010 23:18:52 +0530
Subject: RE: [RFC] mac80211: Fix ibss station got expired immediately
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C5@CHEXMB-01.global.atheros.com>
References: <1287752787-6616-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=DwO_2t_p_+aeh6bBow_NR5=xoPw4A5L8X91ye@mail.gmail.com>
 <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C4@CHEXMB-01.global.atheros.com>,<AANLkTi=FV91Gj0iGT1X3oZF9rmLAKFNwzy=ReqcdRGeL@mail.gmail.com>
In-Reply-To: <AANLkTi=FV91Gj0iGT1X3oZF9rmLAKFNwzy=ReqcdRGeL@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>On Fri, Oct 22, 2010 at 9:48 AM, Rajkumar Manoharan
><Rajkumar.Manoharan@atheros.com> wrote:
>>>On Fri, Oct 22, 2010 at 6:06 AM, Rajkumar Manoharan
>>><rmanoharan@atheros.com> wrote:
>>>> Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
>>>> sta->last_rx which is causing station expiry in ieee80211_ibss_work
>>>> path. So sta addition and deletion happens repeatedly.
>>>>
>>>> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
>>
>>>stable fix?
>>
>>>Luis
> >yes. while sending the patch, i'll cc'd stable.
>
>To get a fix propagated to stable you must adda
>
>Cc: stable@kernel.org
>
>to your commit log right before your Signed-off-by.
>Luis

Yep. thats what i meant ;)

- Rajkumar
