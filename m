Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58467 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbcGHPmK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:42:10 -0400
Subject: Re: ath10k + iw set bitrates is causing FW crash
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com>
 <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
 <1467982766213.21223@qti.qualcomm.com>
 <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com>
 <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com>
 <CABPxzYKOqBmrjRwAyZV9daV8adEhUV71XEAsfrLhtTnKwWzuaw@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <577FC9D0.2010809@candelatech.com> (sfid-20160708_174218_200454_2BBA8835)
Date: Fri, 8 Jul 2016 08:42:08 -0700
MIME-Version: 1.0
In-Reply-To: <CABPxzYKOqBmrjRwAyZV9daV8adEhUV71XEAsfrLhtTnKwWzuaw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/08/2016 08:39 AM, Krishna Chaitanya wrote:

> Also can you please tell me how to make ath10k use minstrel rc, its needed
> for comparative purposes? Is disable HW_RATE_CONTROL enough or does
> it need more changes?

It cannot be done.  You have to use whatever rate-ctrl is baked into the
firmware.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

