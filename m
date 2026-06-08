Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38738D40B
	for <linux-wireless@vger.kernel.org>; Mon,  8 Jun 2026 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780926292; cv=none; b=Otl3Tck+UozEB8HyqszF01B+HHmNE1BrM7LldMZAiIsgdVTItYWrHni1fJlZvTnpvYRX+Pou90bS8AX9Sm4bZfqaKa9OpN8oXUhEwPq9BPiJ5U7OEfJFL9uiPKxC1/0U0QlGzlo8om4oZS10QfOYFzMN6XCFveS1f3IUmregKhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780926292; c=relaxed/simple;
	bh=lxCvq8ERmgGTp5SxzY5C48oW55kYRCwPe+L/9ue4+yY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHcwV0t6qtLGa+uiaTqfgQMP8DZLuzyKdj7IKBvBXl/GD2K8SsAcSwkLqup/eQCEBU+eGg3o/2xhil+5dC7/8dDwvrpLqCHbpNTqyTeWM62E7eOKKEBHDVzPaurlydfAt+JIEwN0mZW2kd2TVZtcwyb6OpPelTYjfX/rjRBKstY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1PF6zVnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1PF6zVnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5C61F00893;
	Mon,  8 Jun 2026 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780926291;
	bh=7ft34wStJM8rr0j/XsQ0Otp6Tph3CNPNKKozVpkNTUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=1PF6zVnjS+FGmL1fGjtQUjm7xqMRYN+dTkbw0AIKuxRBKo1F3fxjM5M6zLZSba5qk
	 QJHbe1l4Ni8UMAolcLQqPzA1idJCcGR0hCbqNGMUjq3AHqvB0ccOGzcHymaLT0PJXJ
	 HNqEleA+S4twjV1P+jBo9Hakzb54TtfYCPjAyDHY=
Date: Mon, 8 Jun 2026 09:44:50 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: postmaster@kernel.org, linux-wireless@vger.kernel.org, 
	Sedat Dilek <sedat.dilek@googlemail.com>
Subject: Re: Unable to unsubscribe from linux-wireless@vger.kernel.org
Message-ID: <20260608-gigantic-vicugna-of-karma-d3d26e@lemur>
References: <1779269054-14963-mlmmj-1e4bac1a@vger.kernel.org>
 <CA+icZUVmdgL1A6mpFxMEtMtikwbkH5qWWyuEn-JOeSU80Q-mvA@mail.gmail.com>
 <CA+icZUWx8_ULgXkiOyeVuJDA4PCTvfFttcdYQphCHausdueu3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUWx8_ULgXkiOyeVuJDA4PCTvfFttcdYQphCHausdueu3A@mail.gmail.com>

On Mon, Jun 08, 2026 at 10:22:04AM +0200, Sedat Dilek wrote:
> Hi Konstantin et all,
> 
> Can you please check or help me find the right person?
> 
> I registered linux-wireless ML via <sedat.dilek@googlemail.com> email
> (email confirmed in monthly bounce-email from ML).
> In 2005 short xxx@gmail.com was not allowed these days for users from Germany.
> This restriction changed some years later.
> 
> All my unsubscription emails are sent as <sedat.dilek@gmail.com> and fail.
> I still get emails from linux-wireless ML.
> 
> So, how can I unsubscribe successfully?
> Any hints/help much appreciated.

I've unsubscribed you.

-K
