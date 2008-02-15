Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:54205 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754228AbYBOXYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 18:24:49 -0500
Received: by py-out-1112.google.com with SMTP id u52so1063229pyb.10
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 15:24:48 -0800 (PST)
Message-ID: <43e72e890802151524q4690f589hcc29ea8645b1d843@mail.gmail.com> (sfid-20080215_232454_010104_4258C3B8)
Date: Fri, 15 Feb 2008 18:24:47 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 2/3] WDEV, ath5k, don't return int from bool function
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	"Nick Kossifidis" <mickflemm@gmail.com>
In-Reply-To: <47B61473.7060206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
	 <1203109133-32217-2-git-send-email-jirislaby@gmail.com>
	 <43e72e890802151408g35fa2e49r5eb8557e4a5bbce4@mail.gmail.com>
	 <47B61473.7060206@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2008 at 5:38 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>
> You mean to consider 0 as supported, -ENODEV/-EOPNOTSUPP as
>  unsupported and the rest as error?
>

Yeap, what do you think?

  Luis
