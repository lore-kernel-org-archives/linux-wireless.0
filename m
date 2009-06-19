Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:2741 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbZFSTWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 15:22:48 -0400
Received: by wf-out-1314.google.com with SMTP id 26so930154wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 12:22:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <83a869cd0906121326r554e6930td9f42d51c2ff4e22@mail.gmail.com>
References: <83a869cd0906121326r554e6930td9f42d51c2ff4e22@mail.gmail.com>
Date: Fri, 19 Jun 2009 21:17:04 +0200
Message-ID: <83a869cd0906191217o298a4cc4u114ba6983d34c1e6@mail.gmail.com>
Subject: Re: [PATCH] b43 : remove old kidx API
From: gregor kowski <gregor.kowski@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/12/09, gregor kowski <gregor.kowski@gmail.com> wrote:
> Remove old kidx API.
> This simplify the code, and fix a potential key overflow.
>
Michael,

any comment on this ?
I wait your ack to resubmit tkip hardware support.

Regards

Gregor.
