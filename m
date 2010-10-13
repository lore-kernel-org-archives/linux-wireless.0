Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49048 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0JMUwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 16:52:07 -0400
Received: by qwa26 with SMTP id 26so1239544qwa.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Oct 2010 13:52:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101013191402.7C6ED9D401B@zog.reactivated.net>
References: <20101013191402.7C6ED9D401B@zog.reactivated.net>
From: Steve deRosier <steve@cozybit.com>
Date: Wed, 13 Oct 2010 13:51:46 -0700
Message-ID: <AANLkTikjknLCFTgowzvfbxHMn=GJ9ffrbLgn5CqePM0T@mail.gmail.com>
Subject: Re: [PATCH] libertas: Fix sd8686 firmware reload
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org, dcbw@redhat.com, pgf@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 13, 2010 at 12:14 PM, Daniel Drake <dsd@laptop.org> wrote:
> From: Paul Fox <pgf@laptop.org>
>
> For the SD8686, we cannot rely on the scratch register to read the firmware
> load status, because the same register is used for storing RX packet length.
> Broaden the check to account for this.
>
> The module can now be unloaded/reloaded successfully.
>
> Based on the implementation from libertas_tf.
>
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Signed-off-by: Steve deRosier <steve@cozybit.com>
