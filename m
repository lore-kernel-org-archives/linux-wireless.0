Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:48545 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaETHeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:34:12 -0400
Received: by mail-lb0-f171.google.com with SMTP id 10so59459lbg.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:34:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 00:33:51 -0700
Message-ID: <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com> (sfid-20140520_093430_714384_61099EB9)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2014 at 1:40 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Introduce support for setting DFS CAC time
> in milliseconds.
>
> Eg.
> (5250 - 5330 @ AUTO), (20), (60000), DFS
>
> will setup CAC 60 seconds CAC time.

Can you elaborate whether or not this will require a bump on CRDA  and
issuing of two new wireless-regdb files for the different versions on
the commit log?

 Luis
