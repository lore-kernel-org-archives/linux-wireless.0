Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45688 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab1F1UG0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 16:06:26 -0400
Received: by iwn6 with SMTP id 6so452231iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 13:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0A30CD.9030006@candelatech.com>
References: <4E0A2F8A.8010102@fedoraproject.org> <4E0A30CD.9030006@candelatech.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 28 Jun 2011 13:06:05 -0700
Message-ID: <BANLkTimRc-SzfeYhiKJ5g9pn3tuUzJM_DQ@mail.gmail.com> (sfid-20110628_220629_414990_E2B303FB)
Subject: Re: [ath9k-devel] [PATCH] ath9k: add module option for disabling 11n functionality
To: Ben Greear <greearb@candelatech.com>
Cc: Michel Alexandre Salim <salimma@fedoraproject.org>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 28, 2011 at 12:51 PM, Ben Greear <greearb@candelatech.com> wrote:
> On 06/28/2011 12:46 PM, Michel Alexandre Salim wrote:
>> Some wireless base stations implement 802.11n mode in ways that
>> open-source drivers cannot handle properly, resulting in very unstable
>> connections. This patch introduces an '11n_disable' option to the ath9k
>> driver, similar to the same option for the iwlagn driver.
>>
>> Tested at the internal wireless network of www.cs.fau.de, where 802.11n
>> currently only works reliably with Windows clients.
>
> Would be lovely if this could be per VIF, and settable through something
> dynamic, even if just debugfs or similar....

WTF. Are such APs WFA certified? Can you provide more details as to
why there is a mode that "open-source drivers cannot handle properly".

  Luis
