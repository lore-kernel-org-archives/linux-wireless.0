Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:57826 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab0JVQw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 12:52:27 -0400
Received: by iwn34 with SMTP id 34so1142097iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 09:52:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C4@CHEXMB-01.global.atheros.com>
References: <1287752787-6616-1-git-send-email-rmanoharan@atheros.com>
 <AANLkTi=DwO_2t_p_+aeh6bBow_NR5=xoPw4A5L8X91ye@mail.gmail.com> <44EE5C37ADC36343B0625A05DD408C4850DAB4D6C4@CHEXMB-01.global.atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Oct 2010 09:52:06 -0700
Message-ID: <AANLkTi=FV91Gj0iGT1X3oZF9rmLAKFNwzy=ReqcdRGeL@mail.gmail.com>
Subject: Re: [RFC] mac80211: Fix ibss station got expired immediately
To: Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 22, 2010 at 9:48 AM, Rajkumar Manoharan
<Rajkumar.Manoharan@atheros.com> wrote:
>>On Fri, Oct 22, 2010 at 6:06 AM, Rajkumar Manoharan
>><rmanoharan@atheros.com> wrote:
>>> Station addition in ieee80211_ibss_rx_queued_mgmt is not updating
>>> sta->last_rx which is causing station expiry in ieee80211_ibss_work
>>> path. So sta addition and deletion happens repeatedly.
>>>
>>> Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
>
>>stable fix?
>
>  >Luis
> yes. while sending the patch, i'll cc'd stable.

To get a fix propagated to stable you must add a

Cc: stable@kernel.org

to your commit log right before your Signed-off-by.

  Luis
