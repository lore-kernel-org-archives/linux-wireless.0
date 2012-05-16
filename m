Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50395 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2EPGIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 02:08:01 -0400
Received: by obbtb18 with SMTP id tb18so588603obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 23:08:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+7oygccmq9DY+dR-=__4z_rZ4Sa9d8zmz+6=zX-xsTKdWkFWQ@mail.gmail.com>
References: <CA+7oygccmq9DY+dR-=__4z_rZ4Sa9d8zmz+6=zX-xsTKdWkFWQ@mail.gmail.com>
Date: Wed, 16 May 2012 08:08:00 +0200
Message-ID: <CAOpc7mEKLM1wjKmdde3YqTuB0edoOFBcH=dK5s5V1y5t7v=wMQ@mail.gmail.com> (sfid-20120516_080806_844207_AA8A10F5)
Subject: Re: AR9280 reported signal strengths are flat (comparison with
 bcm4322 included)
From: Holger Schurig <holgerschurig@googlemail.com>
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is probably due to ANI (adapative noise immunity). I think ath9k
does too much here, in other words: it doesn't just kick in if there
are too strong signals there. Instead it seems to always adjust the
input attenuator, needed or not.
