Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:35170 "EHLO
	mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbcGHPpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 11:45:09 -0400
Received: by mail-yw0-f195.google.com with SMTP id c13so9034267ywh.2
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jul 2016 08:45:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <577FC9D0.2010809@candelatech.com>
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com> <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
 <1467982766213.21223@qti.qualcomm.com> <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com>
 <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com>
 <CABPxzYKOqBmrjRwAyZV9daV8adEhUV71XEAsfrLhtTnKwWzuaw@mail.gmail.com> <577FC9D0.2010809@candelatech.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 8 Jul 2016 21:14:48 +0530
Message-ID: <CABPxzYLdS-QicOj9AdcubT8uxgw0cqXpzerpuwGcwkSQ7PCiOA@mail.gmail.com> (sfid-20160708_174516_991797_6A74643D)
Subject: Re: ath10k + iw set bitrates is causing FW crash
To: Ben Greear <greearb@candelatech.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 8, 2016 at 9:12 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 07/08/2016 08:39 AM, Krishna Chaitanya wrote:
>
>> Also can you please tell me how to make ath10k use minstrel rc, its needed
>> for comparative purposes? Is disable HW_RATE_CONTROL enough or does
>> it need more changes?
>
>
> It cannot be done.  You have to use whatever rate-ctrl is baked into the
> firmware.
Ok, its a good feature to have.
