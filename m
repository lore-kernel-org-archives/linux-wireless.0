Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:41427 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab3JVKvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Oct 2013 06:51:14 -0400
Received: by mail-la0-f52.google.com with SMTP id eh20so1595601lab.39
        for <linux-wireless@vger.kernel.org>; Tue, 22 Oct 2013 03:51:13 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 22 Oct 2013 13:51:12 +0300
Message-ID: <CANUX_P0yTq2v5jWyeHob_QnES878Zw-aZDhWFSmBcxg=CYMHgA@mail.gmail.com> (sfid-20131022_125123_898190_2AA53E24)
Subject: Re: Intel(R) Centrino(R) Advanced-N 6235 - iwlwifi-6000g2b-6.ucode
 not reconnecting issue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Bastiaan de Groot <bastiaan.de.groot@telexis.nl>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 22, 2013 at 11:31 AM, Bastiaan de Groot
<bastiaan.de.groot@telexis.nl> wrote:
> Dear community,
>
> I have a "Intel® Centrino® Advanced-N 6235" wificard.
> Running Debian 7.0 "wheezy"
>
> Firmware: Iwlwifi-6000g2b-6.ucode
>
> Using:
> Kernel 3.2.0-4-686-pae
>
> It connects but when wpa_supplicant is trying to re-connect I get:
>
> [83667.904059] iwlwifi 0000:05:00.0: iwl_hcmd_queue_reclaim: Read index for DMA queue txq id (9), index 157 is out of range [0-256] 0 0.

Did you have anything before that?
