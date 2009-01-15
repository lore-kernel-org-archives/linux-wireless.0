Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:51241 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759456AbZAOR6Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:58:25 -0500
Received: by gxk14 with SMTP id 14so1113458gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 09:58:24 -0800 (PST)
Message-ID: <43e72e890901150958s3212d28cjdd697ae138bdfe8b@mail.gmail.com> (sfid-20090115_185829_438935_4EE1F9AE)
Date: Thu, 15 Jan 2009 09:58:23 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: prevent key2pub.py from generating bogus output on failure
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090110001650.3681.35686.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20090110001650.3681.35686.stgit@dv.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 9, 2009 at 4:16 PM, Pavel Roskin <proski@gnu.org> wrote:
> Specify output file on the command line, so that it's not created in
> case of fatal errors, such as asbence of M2Crypto.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Applied thanks.

  Luis
