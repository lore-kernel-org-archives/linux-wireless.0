Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:2231 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbZAEQEz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 11:04:55 -0500
Message-ID: <49622FA1.5060603@gmail.com> (sfid-20090105_170459_012438_0B6A0490)
Date: Mon, 05 Jan 2009 17:04:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] IWL: fix WARN typo
References: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1231171404-22822-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2009 05:03 PM, Jiri Slaby wrote:
> new kew -> a new key
...
> -		"no space for new kew");
> +		"no space for a new key");

There are more of them, hold on, I'll post an updated one.
