Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:29162 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYKLAtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 19:49:00 -0500
Received: by nf-out-0910.google.com with SMTP id d3so91351nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2008 16:48:58 -0800 (PST)
Message-ID: <491A27F4.7070400@gmail.com> (sfid-20081112_014907_273921_D5A7E7C7)
Date: Wed, 12 Nov 2008 00:48:52 +0000
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] orinoco: fix last beacon reporting on 64-bit systems
References: <20081110142553.12216.42412.stgit@dv.roinet.com>
In-Reply-To: <20081110142553.12216.42412.stgit@dv.roinet.com>
Content-Type: text/plain; charset=utf-8
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> orinoco_translate_scan() and orinoco_translate_ext_scan() wrongly
> truncate last_scanned argument from unsigned long to unsigned int.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Well spotted. IIRC that was the one of the issues you noticed with scan
output when testing my WPA patch series.

ACK from me, if it matters.


Dave.
