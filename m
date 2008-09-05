Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36399 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbYIERo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2008 13:44:28 -0400
Received: by gxk9 with SMTP id 9so7090662gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 05 Sep 2008 10:44:27 -0700 (PDT)
Message-ID: <43e72e890809051044n20826243jab4606b7baf57b0@mail.gmail.com> (sfid-20080905_194458_609300_4C4593FA)
Date: Fri, 5 Sep 2008 10:44:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] cfg80211: Add new wireless regulatory infrastructure
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1220484624-7808-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1220484624-7808-1-git-send-email-lrodriguez@atheros.com>
	 <1220484624-7808-2-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2008 at 4:30 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:

> +#undef OLD_FREQ

Doh this is spurious, I forgot to remove the undef as I am not using
it. Going to resent without this.

 Luis
