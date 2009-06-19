Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f177.google.com ([209.85.210.177]:64472 "EHLO
	mail-yx0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZFSBQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 21:16:04 -0400
MIME-Version: 1.0
In-Reply-To: <b6c5339f0906181814p7f052822je8903629445c8a30@mail.gmail.com>
References: <1245366405-27426-1-git-send-email-jirislaby@gmail.com>
	 <b6c5339f0906181814p7f052822je8903629445c8a30@mail.gmail.com>
Date: Thu, 18 Jun 2009 21:16:05 -0400
Message-ID: <b6c5339f0906181816m15e2a348s3df43602278c22b8@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: fix beacon_int handling
From: Bob Copeland <bcopeland@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath5k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 18, 2009 at 9:14 PM, Bob Copeland<bcopeland@gmail.com> wrote:
>> Otherwise it will be set only once by upper layer through
>> bss_info_changed but not on second and further hostap executions.
>
> Shouldn't we just not destroy the value in add_interface?

Err, nevermind, that's exactly what your patch does.

-- 
Bob Copeland %% www.bobcopeland.com
