Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51623 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752338Ab3HPBVt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 21:21:49 -0400
Message-ID: <1376616107.1947.0.camel@joe-AO722> (sfid-20130816_032152_469654_28E3325F)
Subject: Re: [PATCH 1/2] staging: vt6656: desc.h Remove typedef struct
 tagSRTS_* to new strutures in rxtx.h
From: Joe Perches <joe@perches.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Aug 2013 18:21:47 -0700
In-Reply-To: <1376598205.8200.27.camel@canaries32-MCP7A>
References: <1376598205.8200.27.camel@canaries32-MCP7A>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-15 at 21:23 +0100, Malcolm Priestley wrote:
> The new structures being
> typedef struct tagSRTS_g -> struct vnt_rts_g
> typedef struct tagSRTS_g_FB -> struct vnt_rts_g_fb
> typedef struct tagSRTS_ab -> struct vnt_rts_ab
> typedef struct tagSRTS_a_FB -> struct vnt_rts_a_fb
> 
> These are only needed by rxtc.c so moved to rxtx.h and
> will eventually form part of the structure of
> struct vnt_tx_buffer.

It would be simpler to verify these changes
if you did not do any whitespace modifications
like changing line wrapping at the same time.


