Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:62023 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750AbXKAQrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 12:47:23 -0400
Received: by an-out-0708.google.com with SMTP id b36so80105ana
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 09:47:22 -0700 (PDT)
Message-ID: <43e72e890711010947k72b6cc36n1a3c9cf1f1434d6a@mail.gmail.com> (sfid-20071101_164750_498964_ECB205B6)
Date: Thu, 1 Nov 2007 12:47:20 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [PATCH 7/7] ath5k: Add documentation for struct ath5k_rate
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <40f31dec0711010616u4aec7f87k45c6a422d8cde9cf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo>
	 <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo>
	 <20071101043933.GG21987@pogo> <20071101044059.GH21987@pogo>
	 <40f31dec0711010616u4aec7f87k45c6a422d8cde9cf@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/1/07, Nick Kossifidis <mickflemm@gmail.com> wrote:

> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>
> Also checkout setcurmode function, i believe we can live without all
> this led-timing stuff and clean up both rate tables and related
> functions.

Yeap -- that is where I am sweeping next. The documentation of the
rates was added in  a specific column arrangement for a good reason :)

  Luis
