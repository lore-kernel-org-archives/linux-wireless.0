Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54744 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0LDV4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Dec 2010 16:56:50 -0500
Received: by qwd7 with SMTP id 7so64933qwd.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Dec 2010 13:56:50 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1291491764-6655-2-git-send-email-kilroyd@googlemail.com>
References: <1291491764-6655-1-git-send-email-kilroyd@googlemail.com>
	<1291491764-6655-2-git-send-email-kilroyd@googlemail.com>
Date: Sat, 4 Dec 2010 22:56:50 +0100
Message-ID: <AANLkTinPj5XykC-dC7Me+ZgSiHTringgGJEFOKGbkB93@mail.gmail.com>
Subject: Re: [PATCH 2/2] orinoco: clear countermeasure setting on commit
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org, comes@naic.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 4, 2010 at 8:42 PM, David Kilroy <kilroyd@googlemail.com> wrote:

Truncated description - looks like missing text?

> and interface up.
>
> In these situations, you are usually trying to connect to a new AP, so
> keeping TKIP countermeasures active is confusing. This is already how
> the driver behaves (inadvertently). However, querying SIOCGIWAUTH may
> tell userspace that countermeasures are active when they aren't.
>
> Signed-off by: David Kilroy <kilroyd@googlemail.com>

- Sedat -
