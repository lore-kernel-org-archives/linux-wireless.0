Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:54704 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbYGQP01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 11:26:27 -0400
Received: by rn-out-0910.google.com with SMTP id k40so2113863rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 08:26:26 -0700 (PDT)
Message-ID: <1ba2fa240807170826g7a1d1f54oc5d6cd89a8e45f5a@mail.gmail.com> (sfid-20080717_172632_499341_36930918)
Date: Thu, 17 Jul 2008 18:26:26 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH net-next 2/2] iwlwifi: small compile warnings without CONFIG_IWLWIFI_DEBUG
Cc: "Netdev List" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1216307106.7034.15.camel@iris.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216286365-11703-1-git-send-email-den@openvz.org>
	 <1216286365-11703-2-git-send-email-den@openvz.org>
	 <1ba2fa240807170408w13837d67hcfd1be50fdb07738@mail.gmail.com>
	 <1216293987.7034.5.camel@iris.sw.ru>
	 <1ba2fa240807170437j12547b26l803551b61a805f8d@mail.gmail.com>
	 <1216307106.7034.15.camel@iris.sw.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 17, 2008 at 6:05 PM, Denis V. Lunev <den@openvz.org> wrote:
>> > If you agree with this, I'll resend the patch with
>> > iwl_rx_scan_results_notif modified.
>>
>> Anyhow please send the patch only for scanning. I will apply the rs
>> portion on our new code, which is still not visible...just to avoid
>> conflict. I will keep  your credit
>> Thanks
>> Tomas
>
> could I have your ack for this?
>

ACK


Tomas
