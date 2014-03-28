Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f177.google.com ([209.85.220.177]:43097 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaC1OYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 10:24:34 -0400
Received: by mail-vc0-f177.google.com with SMTP id if17so5850361vcb.36
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2014 07:24:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wqfev2ml.fsf@kamboji.qca.qualcomm.com>
References: <20140328132849.31620.78501.stgit@potku.adurom.net>
	<CA+BoTQmqf8kryKEeD00P6o+N7C+980pEqHnT9qe4H4cjZ+eb=w@mail.gmail.com>
	<87wqfev2ml.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 28 Mar 2014 22:24:33 +0800
Message-ID: <CAEFj985Xq-_QRmdOsFKEM0kA40TpgKL6t1DW8yXSPY6dn=R2LA@mail.gmail.com> (sfid-20140328_152437_028513_529CA392)
Subject: Re: [PATCH v5] ath10k: implement per-VDEV FW statistics
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2014 at 10:06 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> On 28 March 2014 14:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>>>
>>> The WMI_REQUEST_PEER_STAT command with latest (999.999.0.716) FW
>>> can return per-VDEV statistics. Using debugfs we can fetch this info now.
>>>
>>> This is a backward compatible change. In case of older FW the VDEV
>>> statistics are simply not returned.
>>>
>>> kvalo: remove struct wmi_peer_stats_common cast from
>>> ath10k_debug_read_target_stats()
>>
>> I just glanced over the patch and I don't think this is correct.
>>
>> Firmware 10.1.467 has peer_rx_rate but doesn't seem to have vdev stats.
>
> Ok, I need to take a closer look at this. If someone else wants to look
> at this instead, feel free to do that :)
>
I up two AP interfaces in same physical but not able to see two
different vdev in get stats.

----
Chun-Yeow
