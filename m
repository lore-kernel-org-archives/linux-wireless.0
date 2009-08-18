Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:36195 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZHRXeo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 19:34:44 -0400
Received: by an-out-0708.google.com with SMTP id d40so3625812and.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 16:34:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A864BB1.8020307@redfish-solutions.com>
References: <4A864BB1.8020307@redfish-solutions.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 18 Aug 2009 16:34:24 -0700
Message-ID: <43e72e890908181634y435b0c8wdab9fb423046a08f@mail.gmail.com>
Subject: Re: [PATCH] Don't build PCMCIA modules when PCMCIA isn't present
To: "Philip A. Prindeville" <philipp@redfish-solutions.com>
Cc: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Pavel Roskin <proski@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 14, 2009 at 10:46 PM, Philip A.
Prindeville<philipp@redfish-solutions.com> wrote:
> From: Philip A Prindeville <philipp@redfish-solutions.com>
>
> If you're building for a platform that has (for example) no PCMCIA/
> Cardbus, then having a single knob to turn to disable this is a
> major win.  Especially if more devices get add later that are
> PCMCIA-based.

Applied, thanks Phillip.

  Luis
