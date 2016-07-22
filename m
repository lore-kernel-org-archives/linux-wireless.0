Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61088 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbcGVL7t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 07:59:49 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: ath10k + iw set bitrates is causing FW crash
Date: Fri, 22 Jul 2016 11:59:41 +0000
Message-ID: <1469188781289.75799@qti.qualcomm.com> (sfid-20160722_135959_845560_22EF378E)
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com>
 <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
 <1467982766213.21223@qti.qualcomm.com>
 <CABPxzYLO8rzvOJ_1iqng89kYFS-xqC3qstbgETVRJHDpO4rikQ@mail.gmail.com>
 <CABPxzYJPi4CqO+KUFA7=r=zpq_c2vFtrgBQ+nF_nThO-cYrteg@mail.gmail.com>,<CABPxzYKomhw5rF4Crj6sMbmr3VuuDYi=zqN2ky83v-=RJe7Zhg@mail.gmail.com>
In-Reply-To: <CABPxzYKomhw5rF4Crj6sMbmr3VuuDYi=zqN2ky83v-=RJe7Zhg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[...]
> >> Thanks Raj, with this fix the rates are 0-7, if i disable then i am
> >> seeing 0-9, so its
> >> working.
> >>
> >> But i am seeing a weird issues, the moment i give bitrates command,
> >> ath10k no longer does encryption, link is a WPA2-PSK: AES. Even after
> >> interface up/down
> >> it doesn't work.
>> After reboot i dont see the "unencrypted" packet issue, i will do
>> some more testing on limiting the rates, currently in my setup its
>> not reaching MCS9 so cannot verify now.
> Rajkumar,
>
> I am still not able to make mcs9 work, so i have tried to change the Nss to 1
> using iw, but that is not taking affect. This command is not taking effect.
>
you mean not able to fix VHT rates alone. am i right? By auto rate mode, is firmware selecting
mcs9? What is the command used for fixing vht rate?

-Rajkumar