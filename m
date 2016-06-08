Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:33977 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbcFHLjF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 07:39:05 -0400
Received: by mail-vk0-f41.google.com with SMTP id e4so6972796vkb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2016 04:39:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87inxrzqa5.fsf@kamboji.qca.qualcomm.com>
References: <1463489221-24989-1-git-send-email-michal.kazior@tieto.com> <87inxrzqa5.fsf@kamboji.qca.qualcomm.com>
From: Roman Yeryomin <leroi.lists@gmail.com>
Date: Wed, 8 Jun 2016 14:39:03 +0300
Message-ID: <CACiydbLvke0UxJbg2sn0q-=FwXpmX+FKUV7wwEMT=qUYekJrJA@mail.gmail.com> (sfid-20160608_133909_994099_47E9CC1E)
Subject: Re: [RFC/RFT] ath10k: disable wake_tx_queue for older devices
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: "michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 June 2016 at 16:14, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Some setups suffer performance regressions with
>> current wake_tx_queue implementation.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>> Hi Roman,
>>
>> Can you give this patch a try and see if it helps
>> with your performance problems, please?
>
> Did anyone seeing the performance regression manage to test this? It
> would be good to get feedback, good or bad, before I push this to 4.7.
>
> Full patch here:
>
> https://patchwork.kernel.org/patch/9111981/

Sorry, didn't try yet, bad timing for me :(
Will try to test by the end of the week

Regards,
Roman
