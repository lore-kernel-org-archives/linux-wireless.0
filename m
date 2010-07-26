Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38008 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab0GZRX5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jul 2010 13:23:57 -0400
Received: by pzk26 with SMTP id 26so1075523pzk.19
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 10:23:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C4D5560.2040201@iam.unibe.ch>
References: <4C4D5560.2040201@iam.unibe.ch>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 26 Jul 2010 10:23:37 -0700
Message-ID: <AANLkTinfWZaiMsmPTmm5qrBRcqMAvQpv1Xq86fxo+S3Z@mail.gmail.com>
Subject: Re: iw dev wlan0 link - "Not connected"
To: Zhongliang Zhao <zhao@iam.unibe.ch>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 26, 2010 at 2:29 AM, Zhongliang Zhao <zhao@iam.unibe.ch> wrote:
> Dear all,
>
> When I use "iw dev wlan0 link" to get information on wlan0 (basically to
> check the channel used on wlan0),
> it says: " Not connected "
>
> Can someone tell me how to fix this?

Refer to:

http://wireless.kernel.org/en/users/Documentation/iw#Getting_link_status

And then:

http://wireless.kernel.org/en/users/Documentation/iw#Establishing_a_basic_connection

What you really want to use is:

http://wireless.kernel.org/en/users/Documentation/wpa_supplicant

  Luis
