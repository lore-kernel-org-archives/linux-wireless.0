Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:52133 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbYCQSSG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 14:18:06 -0400
Received: by wf-out-1314.google.com with SMTP id 28so5554485wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 11:18:03 -0700 (PDT)
Message-ID: <43e72e890803171118x4b59dbbfu5e57574eeabb10b3@mail.gmail.com> (sfid-20080317_181815_200354_8773EF20)
Date: Mon, 17 Mar 2008 14:18:03 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tanner Xero Ezell" <tanner.ezell@gmail.com>
Subject: Re: Intel 4965AGN and 802.11n
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47DE2517.9070601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47DE2517.9070601@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 4:00 AM, Tanner Xero Ezell
<tanner.ezell@gmail.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
>  Hash: SHA1
>
>  Hello all,
>
>  I've been trying for the last few days to get .11n support working on my
>  Thinkpad with the 4965 card to no avail, i have downloaded, compiled and
>  ran the kernel from wireless experimental git repo, and although i
>  enabled it in the configuration, when loaded, (modprobe iwl4965
>  qos_enable=1) dmesg reports "Tunable channels" to 802.11bg and 802.11a,
>  but no n. is there something special i must do? Is there a guide or
>  anything anywhere to get 11n support working at all? I'm using ubuntu
>  7.10 and have tried the compat-wireless package to no avail.
>
>  Any help would be most appreciated!

Please keep in mind I only enabled CONFIG_IWL4965_HT on
compat-wireless by default on Friday so if you downloaded
compat-wireless before that then it wasn't enabled unless you did so
manually by editing config.mk. Just wanted to point that out.

  Luis
